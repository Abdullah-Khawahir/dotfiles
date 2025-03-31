import argparse
import openai
import os

def transcribe(audio_file):
    client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    with open(audio_file, "rb") as f:
        response = client.audio.transcriptions.create(
            model="whisper-1",
            file=f
        )
    print(response.text)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Transcribe audio using OpenAI Whisper API\n"
                                     "Ensure you export OPENAI_API_KEY before running this script.")
    parser.add_argument("audio_file", help="Path to the audio file (mp3, wav, m4a, etc.)")
    args = parser.parse_args()

    transcribe(args.audio_file)
