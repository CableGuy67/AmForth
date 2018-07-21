#
#    Mecrisp-Quintus - A native code Forth implementation for RISC-V
#    Copyright (C) 2018  Matthias Koch
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

CODEWORD Flag_visible, "cold", COLD

  # This is the same as in quit, in order to prepare for whatever the user might want to do within "init".

  li sp, RAM_upper_returnstack
  li x4, RAM_upper_datastack

  .ifdef initflash
  call initflash
  .endif

  la x17, XT_WARM
  j DO_EXECUTE
