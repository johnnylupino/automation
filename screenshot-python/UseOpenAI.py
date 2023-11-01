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

    # Now you can use the OpenAI API
    #response = openai.Completion.create(engine="text-davinci-002", prompt="Translate the following English text to French: '{}'", max_tokens=60)
    #print(response.choices[0].text.strip())

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