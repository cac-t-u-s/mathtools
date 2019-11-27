;=========================================================================
;  OpenMusic: Visual Programming Language for Music Composition
;
;  Copyright (c) 1997-... IRCAM-Centre Georges Pompidou, Paris, France.
; 
;    This file is part of the OpenMusic environment sources
;
;    OpenMusic is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    OpenMusic is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with OpenMusic.  If not, see <http://www.gnu.org/licenses/>.
;
; Authors: Gerard Assayag, Augusto Agon, Jean Bresson
;=========================================================================

;;; MATHTOOLS by C. Agon, M. Andreatta et al.

(in-package :om)

(defclass! crible ()
  ((cr-exp :initform '(2 0 18) :initarg :cr-exp :accessor cr-exp)
   (maxn :initform 0 :accessor maxn))
  (:icon 423))


(defmethod initialize-instance ((self crible)  &rest rest)
  (declare (ignore rest))
  (call-next-method)
  (if (not (stringp (car (cr-exp self))))
    (setf (maxn self) (third (cr-exp self)))
    (setf (maxn self) (apply 'max (mapcar 'maxn (cdr (cr-exp self))))))
  self)

(defmethod! c-union ((self crible) (crible crible) &rest rest)
  :doc "It makes the set-theoretical union of two sieves or cribles" 
  :icon 423
  (let* ((c-list (append (list self crible) rest))
         (newc (make-instance 'crible
                 :cr-exp (cons "crible-u" c-list))))
    newc ))

(defmethod! c-intersection ((self crible) (crible crible) &rest rest)
  :doc "It makes the set-theoretical intersection of two sieves or cribles"
  :icon 423
  (let* ((c-list (append (list self crible) rest))
         (newc (make-instance 'crible
                 :cr-exp (cons "crible-i" c-list))))
    newc))

(defmethod! c-complement ((self crible))
  :doc "It makes the set-theoretical complement of a sieve or crible with respect to the total chromatic universe"
  :icon 423
  (let* ((newc (make-instance 'crible
                 :cr-exp (list "crible-c" self))))
    newc))
    


(defun crible-u (&rest rest)
  (let (rep)
    (loop for item in rest do
          (setf rep (union rep item)))
    rep))

(defun crible-i (&rest rest)
  (let ((rep (car rest)))
    (loop for item in rest do
          (setf rep (intersection rep item)))
    rep))

#|
;; not finished ?
(defun crible-c (crible)
  (let (total )
    (loop for item in rest do
          (setf rep (union rep item)))
    rep))
|#

(defmethod! revel-crible ((self crible))
  :doc "It makes visible the crible object by giving its corresponding residual classes values. You can connect the revel-crible object to an n-cercle in order to see a possible circular representation of a given sieve.  "
  :icon 423
  (cond
   ((not (stringp (car (cr-exp self))))
    (loop for i from (second (cr-exp self)) to (third (cr-exp self)) by (first (cr-exp self))
          collect i))
   ((string-equal (car (cr-exp self)) "crible-c")
    (let ((total (loop for i from 0 to (maxn (second (cr-exp self)))  collect i)))
      (sort (set-difference total (revel-crible  (second (cr-exp self)))) '<)))
   (t
    (let ((function (intern (string-upcase (car (cr-exp self)))))
          (args (cdr (cr-exp self))))
      (sort (apply function (loop for item in args collect (revel-crible item))) '<)))
  ))


(defmethod! revel-crible ((self list))
  (mapcar 'revel-crible self))

(defmethod! revel-crible ((self t))
  nil)

