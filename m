Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J8babY161631 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 03:37:37 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF8F07D63F
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 01:37:34 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id rLSn3gaONubyARK6 for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2011 01:37:34 -0700 (PDT)
Date: Tue, 19 Jul 2011 10:37:19 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Message-ID: <20110719103719.18c4773f@galadriel.home>
In-Reply-To: <4E24907F.6020903@johnbokma.com>
References: <4E24907F.6020903@johnbokma.com>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Bokma <contact@johnbokma.com>
Cc: xfs@oss.sgi.com

TGUgTW9uLCAxOCBKdWwgMjAxMSAxNDo1ODo1NSAtMDUwMCB2b3VzIMOpY3JpdmllejoKCj4gY2Fy
ZDogTWVnYVJBSUQgU0FTIDkyNjAtMTZpCj4gZGlza3M6IDE0eCBCYXJyYWN1ZGHCriBYVCBTVDMz
MDAwNjUxQVMgM1RCICgyIGhvdCBzcGFyZXMpLgo+IFJBSUQ2Cj4gfiAzMFRCCj4gCgpUaGlzIGNh
cmQgZG9lc24ndCBhY3RpdmF0ZSB0aGUgd3JpdGUgY2FjaGUgd2l0aG91dCBhIEJCVSBwcmVzZW50
LiBCZQpzdXJlIHlvdSBoYXZlIGEgQkJVIG9yIHRoZSBwZXJmb3JtYW5jZSB3aWxsIGFsd2F5cyBi
ZSB1bmJlYXJhYmx5IGF3ZnVsLgpUaGVuIHByb2NlZWQgbGlrZSBFcmljIHN1Z2dlc3RlZC4gSW5p
dGlhbGl6ZSB5b3VyIGZpbGVzeXN0ZW0gd2l0aCB0aGUKcmlnaHQgb3B0aW9ucyA6IHN1PSB5b3Vy
IFJBSUQgc3RyaXBlIHNpemUsIHN3PSB5b3VyIFJBSUQgYXJyYXkgZGF0YQptZW1iZXJzIChmb3Ig
UkFJRCA2LCB0aGUgdG90YWwgbnVtYmVyIG1pbnVzIDIpLCBkb24ndCBmb3JnZXQgdGhlIHVzZWZ1
bApvcHRpb24gLWwgbGF6eS1jb3VudD0xLCBhbmQgbW91bnQgd2l0aCBub2JhcnJpZXJzIGFuZCBp
bm9kZTY0LgoKQlRXIGFwcGFyZW50bHkgeW91J3JlIGNvbmZ1c2luZyBob3Qgc3BhcmVzIGFuZCBw
YXJpdHkgZHJpdmVzLiBBIFJBSUQtNgphcnJheSBoYXMgMiBwYXJpdHkgZHJpdmVzOyB0aGVuIGl0
IG1heSBoYXZlIG9yIG5vdCAxIG9yIG1vcmUgaG90IHNwYXJlcwooZ2VuZXJhbGx5IG9uZSBpcyBl
bm91Z2gpLiBJIHN1cHBvc2UgeW91ciBhcnJheSBpcyBhY3R1YWxseSBhIDEyIGRhdGEgKwoyIHBh
cml0eSBkcml2ZXMuCgpyZWdhcmRzLAotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3Jh
YyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8ICAgSW50
ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAg
ICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxp
bmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGlu
Zm8veGZzCg==
