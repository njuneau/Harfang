// Harfang - A Web development framework
// Copyright (C) Nicolas Juneau <n.juneau@gmail.com>
// Full copyright notice can be found in the project root's "COPYRIGHT" file
//
// This file is part of Harfang.
//
// Harfang is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Harfang is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Harfang.  If not, see <http://www.gnu.org/licenses/>.

package requestdispatcher;

import unit2.TestCase;

import harfang.server.request.RequestInfo;

/**
 * Tests the request info model class
 */
class RequestInfoTest extends TestCase {

    /**
     * Tests slash appending on strings without accents
     */
    @Test
    public function testAppendSlash() : Void {
        var rqInfo : RequestInfo = new RequestInfo("/normal", "GET");
        this.assertEquals("/normal/", rqInfo.getURI());

        var rqInfoSlash : RequestInfo = new RequestInfo("/normal/", "GET");
        this.assertEquals("/normal/", rqInfoSlash.getURI());

        var rqInfoMid : RequestInfo = new RequestInfo("/normal/a", "GET");
        this.assertEquals("/normal/a/", rqInfoMid.getURI());
    }

    /**
     * Tests slash appending on strings with accentuated characters
     */
    @Test
    public function testAppenSlashAccented() : Void {
        var rqInfo : RequestInfo = new RequestInfo("/éàè", "POST");
        this.assertEquals("/éàè/", rqInfo.getURI());

        var rqInfoSlash : RequestInfo = new RequestInfo("/éàè/", "POST");
        this.assertEquals("/éàè/", rqInfo.getURI());

        var rqInfoMid : RequestInfo = new RequestInfo("/éàè/ï", "POST");
        this.assertEquals("/éàè/ï/", rqInfoMid.getURI());
    }

}