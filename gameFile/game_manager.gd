extends Node
var money := 500

func can_afford(amount: int) -> bool:
	return money >= amount

func spend_money(amount: int) -> bool:
	if money >= amount:
		money -=  amount
		return true
		
	return false

func add_money(amount: int):
	money += amount
