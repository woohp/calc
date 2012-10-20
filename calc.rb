
def expr0(str, i, j)
  accum, i = expr1(str, i, j)
  
  while i < j
    op = str[i]

    if op == '+'
      rightNum, i = expr1(str, i+1, j)
      accum += rightNum
    elsif op == '-'
      rightNum, i = expr1(str, i+1, j)
      accum -= rightNum
    else
      break
    end
  end

  return [accum, i]
end


def expr1(str, i, j)
  accum, i = expr2(str, i, j)

  while i < j
    op = str[i]

    if op == '*'
      rightNum, i = expr2(str, i+1, j)
      accum *= rightNum
    elsif op == '/'
      rightNum, i = expr2(str, i+1, j)
      accum /= rightNum
    else
      break
    end
  end

  return [accum, i]
end


def expr2(str, i, j)
  accum, i = atom(str, i, j)

  while i < j
    op = str[i]

    if op == '^'
      rightNum, i = atom(str, i+1, j)
      accum **= rightNum
    else
      break
    end
  end

  return [accum, i]
end


def atom(str, i, j)
  if str[i] == '('
    # extract out the expression inside the parenthesis
    numParen = 1
    tempIndex = i
    while numParen > 0 and tempIndex < j
      tempIndex += 1
      if str[tempIndex] == '('
        numParen += 1
      elsif str[tempIndex] == ')'
        numParen -= 1
      end
    end

    # recursively call to evaluate the parenthesis expression
    parenResult, dummy = expr0(str, i+1, tempIndex)
    return [parenResult, tempIndex+1]
  else
    isNegative = false
    if str[i] == '-'
      isNegative = true
      i += 1
    end

    # parse out the whole part of the number
    num = 0.0
    while i < j and str[i].ord >= 48 and str[i].ord <= 57
      num = num * 10 + (str[i].ord - 48)
      i += 1
    end

    # parse out the decimal part
    if i < j and str[i] == '.'
      i += 1
      decimalPlace = 10.0
      while i < j and str[i].ord >= 48 and str[i].ord <= 57
        num = num + ((str[i].ord - 48) / decimalPlace)
        decimalPlace *= 10
        i += 1
      end
    end
    num = -num if isNegative

    return [num, i]
  end
end


def evaluate(str)
  str = str.gsub(/\s+/, '')
  return expr0(str, 0, str.size)[0]
end


puts evaluate(ARGV[0])

