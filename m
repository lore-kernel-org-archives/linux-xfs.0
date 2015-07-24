Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4430E7FA3
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 11:00:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E96218F8068
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 09:00:10 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id rfGRBV7Hp2GWwukt (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Jul 2015 09:00:09 -0700 (PDT)
Subject: Bug#793496: About the security issues affecting xfsprogs in Squeeze
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.793496.B793496.143775346622293@bugs.debian.org>
Date: Fri, 24 Jul 2015 17:57:44 +0200
From: Raphael Hertzog <hertzog@debian.org>
Message-ID: <20150724155744.GA21140@home.ouaza.com>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: Raphael Hertzog <hertzog@debian.org>, 793496@bugs.debian.org
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
To: Nathan Scott <nathans@debian.org>
Cc: 793496@bugs.debian.org, debian-lts@lists.debian.org

SGVsbG8gTmF0aGFuLAoKdGhlIERlYmlhbiBMVFMgdGVhbSByZWNlbnRseSByZXZpZXdlZCB0aGUg
c2VjdXJpdHkgaXNzdWUocykgYWZmZWN0aW5nIHlvdXIKcGFja2FnZSBpbiBTcXVlZXplOgpodHRw
czovL3NlY3VyaXR5LXRyYWNrZXIuZGViaWFuLm9yZy90cmFja2VyL0NWRS0yMDEyLTIxNTAKCldl
IGRlY2lkZWQgdGhhdCB3ZSB3b3VsZCBub3QgcHJlcGFyZSBhIHNxdWVlemUgc2VjdXJpdHkgdXBk
YXRlICh1c3VhbGx5CmJlY2F1c2UgdGhlIHNlY3VyaXR5IGltcGFjdCBpcyBsb3cgYW5kIHRoYXQg
d2UgY29uY2VudHJhdGUgb3VyIGxpbWl0ZWQKcmVzb3VyY2VzIG9uIGhpZ2hlciBzZXZlcml0eSBp
c3N1ZXMgYW5kIG9uIHRoZSBtb3N0IHdpZGVseSB1c2VkIHBhY2thZ2VzKS4KVGhhdCBzYWlkIHRo
ZSBzcXVlZXplIHVzZXJzIHdvdWxkIG1vc3QgY2VydGFpbmx5IGJlbmVmaXQgZnJvbSBhIGZpeGVk
CnBhY2thZ2UuCgpJZiB5b3Ugd2FudCB0byB3b3JrIG9uIHN1Y2ggYW4gdXBkYXRlLCB5b3UncmUg
d2VsY29tZSB0byBkbyBzby4gUGxlYXNlCnRyeSB0byBmb2xsb3cgdGhlIHdvcmtmbG93IHdlIGhh
dmUgZGVmaW5lZCBoZXJlOgpodHRwOi8vd2lraS5kZWJpYW4ub3JnL0xUUy9EZXZlbG9wbWVudAoK
SWYgdGhhdCB3b3JrZmxvdyBpcyBhIGJ1cmRlbiB0byB5b3UsIGZlZWwgZnJlZSB0byBqdXN0IHBy
ZXBhcmUgYW4KdXBkYXRlZCBzb3VyY2UgcGFja2FnZSBhbmQgc2VuZCBpdCB0byBkZWJpYW4tbHRz
QGxpc3RzLmRlYmlhbi5vcmcKKHZpYSBhIGRlYmRpZmYsIG9yIHdpdGggYW4gVVJMIHBvaW50aW5n
IHRvIHRoZSB0aGUgc291cmNlIHBhY2thZ2UsCm9yIGV2ZW4gd2l0aCBhIHBvaW50ZXIgdG8geW91
ciBwYWNrYWdpbmcgcmVwb3NpdG9yeSksIGFuZCB0aGUgbWVtYmVycwpvZiB0aGUgTFRTIHRlYW0g
d2lsbCB0YWtlIGNhcmUgb2YgdGhlIHJlc3QuIEhvd2V2ZXIgcGxlYXNlIG1ha2Ugc3VyZSB0bwpz
dWJtaXQgYSB0ZXN0ZWQgcGFja2FnZS4KClRoYW5rIHlvdSB2ZXJ5IG11Y2guCgpSYXBoYcOrbCBI
ZXJ0em9nLAogIG9uIGJlaGFsZiBvZiB0aGUgRGViaWFuIExUUyB0ZWFtLgotLSAKUmFwaGHDq2wg
SGVydHpvZyDil4ggRGViaWFuIERldmVsb3BlcgoKU3VwcG9ydCBEZWJpYW4gTFRTOiBodHRwOi8v
d3d3LmZyZWV4aWFuLmNvbS9zZXJ2aWNlcy9kZWJpYW4tbHRzLmh0bWwKTGVhcm4gdG8gbWFzdGVy
IERlYmlhbjogaHR0cDovL2RlYmlhbi1oYW5kYm9vay5pbmZvL2dldC8KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
