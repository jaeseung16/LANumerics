import Foundation

public extension Matrix {
    
    func map<E>(_ transform : (Element) -> E) -> Matrix<E> {
        return Matrix<E>(rows: _rows, columns: _columns, elements: elements.map(transform))
    }

    func combine<E, F>(_ other : Matrix<E>, _ using : (Element, E) -> F) -> Matrix<F> {
        precondition(hasSameDimensions(other))
        let C = count
        var elems = [F](repeating: F.zero, count: C)
        asPointer(self.elements) { elems1 in
            asPointer(other.elements) { elems2 in
                asMutablePointer(&elems) { elems in
                    for i in 0 ..< C {
                        elems[i] = using(elems1[i], elems2[i])
                    }
                }
            }
        }
        return Matrix<F>(rows: _rows, columns: _columns, elements: elems)
    }
    
    func fold<F>(_ start : F, _ using : (F, Element) -> F) -> F {
        var result = start
        for elem in elements {
            result = using(result, elem)
        }
        return result
    }
    
    func fold(_ using : (Element, Element) -> Element) -> Element {
        return fold(Element.zero, using)
    }
    
    func forall(_ cond : (Element) -> Bool) -> Bool {
        for elem in elements {
            guard cond(elem) else { return false }
        }
        return true
    }

    func exists(_ cond : (Element) -> Bool) -> Bool {
        for elem in elements {
            if cond(elem) { return true }
        }
        return false
    }

    
}
