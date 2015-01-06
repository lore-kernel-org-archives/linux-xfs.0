Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17CEB7F5F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:56:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA6568F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:56:15 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id OLTCogoJCLWGFFi3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:56:14 -0800 (PST)
Date: Tue, 6 Jan 2015 18:56:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: a simple and scalable pNFS block layout server
Message-ID: <20150106175611.GA16413@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<20150106173222.GF12067@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106173222.GF12067@fieldses.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

T24gVHVlLCBKYW4gMDYsIDIwMTUgYXQgMTI6MzI6MjJQTSAtMDUwMCwgSi4gQnJ1Y2UgRmllbGRz
IHdyb3RlOgo+IAktIGRvIHdlIGhhdmUgZXZpZGVuY2UgdGhhdCB0aGlzIGlzIHVzZWZ1bCBpbiBp
dHMgY3VycmVudCBmb3JtPwoKV2hhdCBpcyB5b3VyIHRocmVzaG9sZCBmb3IgdXNlZnVsbmVzcz8g
IEl0IHBhc3NlcyB4ZnN0ZXN0cyBmaW5lLCBhbmQKc2hvd3MgbGluZWFyIHNjYWxhYmlsaXR5IHdp
dGggbXVsdGlwbGUgY2xpZW50cyB0aGF0IGVhY2ggaGF2ZSAxMEdCCmxpbmtzLiAKCj4gCS0gYW55
IGFkdmljZSBvbiB0ZXN0aW5nPyAgSXMgdGhlcmUgd2FzIHNvbWUgc2ltcGxlIHZpcnR1YWwgc2V0
dXAKPiAJICB0aGF0IHdvdWxkIGFsbG93IGFueSBsb3NlciB3aXRoIG5vIHNwZWNpYWwgaGFyZHdh
cmUgKGUuZy4sIG1lKQo+IAkgIHRvIGNoZWNrIHdoZXRoZXIgdGhleSd2ZSBicm9rZW4gdGhlIGJs
b2NrIHNlcnZlcj8KClJ1biB0d28ga3ZtIFZNcyB0aGF0IHNoYXJlIHRoZSBzYW1lIGRpc2suICBD
cmVhdGUgYW4gWEZTIGZpbGVzeXN0ZW0Kb24gdGhlIE1EUywgYW5kIGV4cG9ydCBpdC4gIElmIHRo
ZSBjbGllbnQgaGFzIGJsa21hcGQgcnVubmluZyAob24gRGViaWFuCml0IG5lZWRzIHRvIGJlIHN0
YXJ0ZWQgbWFudWFsbHkpIGl0IHdpbGwgdXNlIHBORlMgZm9yIGFjY2Vzc2luZyB0aGUKZmlsZXN5
c3RlbS4gIFZlcmlmeSB0aGF0IHVzaW5nIHRoZSBwZXItb3BlcmF0aW9uIGNvdW50ZXJzIGluCi9w
cm9jL3NlbGYvbW91bnN0YXRzLiAgUmVwZWF0IHdpdGggYWRkaXRpb25hbCBjbGllbnRzIGFzIG5l
c3NlY2FyeS4KCkFsdGVybmF0aXZlbHkgc2V0IHVwIGEgc2ltcGxlIGlTQ1NJIHRhcmdldCB1c2lu
ZyB0Z3Qgb3IgbGlvIGFuZApjb25uZWN0IHRvIGl0IGZyb20gbXVsdGlwbGUgY2xpZW50cy4KCj4g
CS0gYW55IGRlYnVnZ2luZyBhZHZpY2U/ICBFLmcuLCBoYXZlIHlvdSBjaGVja2VkIGlmIGN1cnJl
bnQKPiAJICB3aXJlc2hhcmsgY2FuIGhhbmRsZSB0aGUgTURTIHRyYWZmaWM/CgpUaGUgd2lyZXNo
YXJlIHZlcnNpb24gSSd2ZSB1c2VkIGRlY29kZWQgdGhlIGdlbmVyaWMgcE5GUyBvcGVyYXRpb25z
CmZpbmUsIGJ1dCBqdXN0IGR1bXBzIHRoZSBsYXlvdXQgc3BlY2lmaWNzIGFzIGhleCBkYXRhLgoK
RW5hYmxlIHRoZSB0cmFjZSBwb2ludHMgYWRkZWQgaW4gdGhpcyBzZXJpZXMsIHRoZXkgdHJhY2sg
YWxsIHN0YXRlaWQKaW50ZXJhY3Rpb25zIGluIHRoZSBzZXJ2ZXIuICBBZGRpdNGWb25hbGx5IHRo
ZSBwbmZzIGRlYnVnIHByaW50a3Mgb24KY2xpZW50IGFuZCBzZXJ2ZXIgZHVtcCBhIGxvdCBvZiBp
bmZvcm1hdGlvbi4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
