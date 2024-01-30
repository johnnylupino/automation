from robocorp import vault
from robocorp.tasks import task
import openai

@task
def my_entry_point():
    # Get the secret from the vault
    secrets = vault.get_secret("openai")
    openai_key = secrets["secret"]

    # Set the OpenAI key
    openai.api_key = openai_key


    try:
    # Attempt to open and read the file
        with open('hex_colors.txt', 'r') as file:
            text = file.read()
            sort_hex(text)
    except FileNotFoundError:
        print("The file could not be found.")
    except PermissionError:
        print("You do not have permission to read the file.")
    except Exception as e:
        # Catch any other exceptions
        print(f"An error occurred: {e}")

def sort_hex(text):
    # Start a conversation with the model
    question = f"Can you sort colors from the following file {text} from darkest to lightest?"
    response = openai.ChatCompletion.create(
    model="gpt-3.5-turbo",
    messages=[
            {"role": "system", "content": "You are a helpful assistant."},
         {"role": "user", "content": question},
        ]
    )

    # The response will contain the answer to your question
    print(response['choices'][0]['message']['content'])
    colors = response['choices'][0]['message']['content']
    get_ai_output_into_lines(colors)

def get_ai_output_into_lines(colors):
    import re

    text = colors
    pattern = r'^\d+\.\s*(.*?)$'
    matches = re.findall(pattern, text, flags=re.MULTILINE)

    # Output the matched lines
    with open('hex_colors_sorted.txt', 'w') as file:
        for match in matches:
            file.writelines(match + "\n")
    file.close()