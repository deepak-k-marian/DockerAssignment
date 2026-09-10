def fiboSeries(n):
    a = 0
    b = 1
    for _ in range(n):
        yield a
        a, b = b, a + b

def getInput():
    while True:
        try:
            num = int(input("Enter a number: "))
            if num < 0:
                print("Please enter a positive number greater than 0.")
                continue
            return num
        except ValueError:
            print("Not a number! Please try again.")

num = getInput()

print(f"Fibonacci sequence ({num} terms):")
for value in fiboSeries(num):
    print(value, end=" ")
print()
