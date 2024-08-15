import os

def clean_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for line in lines:
            cleaned_line = line.rstrip() + '\n'
            file.write(cleaned_line)

def clean_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.swift'):
                clean_file(os.path.join(root, file))

if __name__ == '__main__':
    project_directory = '/Users/appinatorstechnology/Documents/Cloud\ Vault/CloudVault '  # You can specify your project directory here
    clean_directory(project_directory)

