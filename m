Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 737277F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 23:54:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A3F2AC003
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 21:54:21 -0800 (PST)
Received: from mail-pb0-f49.google.com (mail-pb0-f49.google.com
	[209.85.160.49]) by cuda.sgi.com with ESMTP id eaw2Sq6CVcz80M1B
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Feb 2013 21:54:21 -0800 (PST)
Received: by mail-pb0-f49.google.com with SMTP id xa12so208195pbc.36
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 21:54:20 -0800 (PST)
From: Hemanth Kumar <hemanthkumar51@gmail.com>
Subject: [Tests] xfs test[298]: Btrfs Quota testing
Date: Fri, 22 Feb 2013 11:24:04 +0530
Message-Id: <1361512444-3451-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: chethan.casey@gmail.com, sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com, praneethu.u@gmail.com, hugo@carfax.org.uk, bo.li.liu@oracle.com, skjmca51@gmail.com, Hemanth Kumar <hemanthkumar51@gmail.com>, kirantpatil@gmail.com

ClNpZ25lZC1vZmYtYnk6IEhlbWFudGggS3VtYXIgPGhlbWFudGhrdW1hcjUxQGdtYWlsLmNvbT4K
LS0tCiAyOTggICAgIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwog
Mjk4Lm91dCB8IDEyICsrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA0OSBpbnNlcnRpb25z
KCspCiBjcmVhdGUgbW9kZSAxMDA2NDQgMjk4CiBjcmVhdGUgbW9kZSAxMDA2NDQgMjk4Lm91dAoK
ZGlmZiAtLWdpdCBhLzI5OCBiLzI5OApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAw
Li5kNjk5ZmI3Ci0tLSAvZGV2L251bGwKKysrIGIvMjk4CkBAIC0wLDAgKzEsMzcgQEAKKworIyEg
L2Jpbi9iYXNoCisjIEZTIFFBIFRlc3QgTm8uIDI5OAorIworIyBUZXN0IGJ0cmZzJ3MgcXVvdGFz
CisjCisjLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCisjCisjIGNyZWF0b3IKKyNvd25lcj1oZW1hbnRoa3VtYXI1MUBnbWFp
bC5jb20KKworCitzZXE9YGJhc2VuYW1lICQwYAorZWNobyAiUUEgb3V0cHV0IGNyZWF0ZWQgYnkg
JHNlcSIKKworaGVyZT1gcHdkYAordG1wPS90bXAvJCQKK3N0YXR1cz0xICAgICAgICAjIGZhaWx1
cmUgaXMgdGhlIGRlZmF1bHQhCisKK19jbGVhbnVwKCkKK3sKKyAgICBybSAtcmYgJHRtcC4qCit9
CisKK3RyYXAgIl9jbGVhbnVwIDsgZXhpdCBcJHN0YXR1cyIgMCAxIDIgMyAxNQorCisjRW5hYmVs
aW5nIGJ0cmZzIHF1dGFzCitidHJmcyBxdW90YSBlbmFibGUgJFRFU1RfRElSCitlY2hvICJxdW90
YSBlbmFibGVkIG9uICRURVNUX0RFViIKK2J0cmZzIHN1YnZvbHVtZSBjcmVhdGUgJFRFU1RfRElS
L3ZvbDEKK2VjaG8gInZvbDEgY3JlYXRlZCIKK2J0cmZzIHFncm91cCBzaG93ICRURVNUX0RJUgor
YnRyZnMgcWdyb3VwIGxpbWl0IDJtICRURVNUX0RJUi92b2wxCitlY2hvICJxZ3JvdXAgbGltaXRl
ZCB0byAybWIiCitkZCBpZj0kVEVTVF9ERVYgb2Y9JFRFU1RfRElSL3ZvbDEvZmlsZTEgYnM9M00g
Y291bnQ9MQorZWNobyAidHJpZWQgdG8gd3JpdGUgM20gd29ydGggZGF0YSIKK2V4aXQKZGlmZiAt
LWdpdCBhLzI5OC5vdXQgYi8yOTgub3V0Cm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAw
MDAuLjM0NGFiN2YKLS0tIC9kZXYvbnVsbAorKysgYi8yOTgub3V0CkBAIC0wLDAgKzEsMTIgQEAK
K1FBIG91dHB1dCBjcmVhdGVkIGJ5IDI5OAorcXVvdGEgZW5hYmxlZCBvbiAvZGV2L3NkYjUKK0Ny
ZWF0ZSBzdWJ2b2x1bWUgJy90ZXN0L3ZvbDEnCit2b2wxIGNyZWF0ZWQKKzAvMjU3IDQwOTYgNDA5
NgorcWdyb3VwIGxpbWl0ZWQgdG8gMm1iCitkZDogd3JpdGluZyDigJgvdGVzdC92b2wxL2ZpbGUx
4oCZOiBEaXNrIHF1b3RhIGV4Y2VlZGVkCisxKzAgcmVjb3JkcyBpbgorMCswIHJlY29yZHMgb3V0
CisyMDMxNjE2IGJ5dGVzICgyLjAgTUIpIGNvcGllZCwgMC4xMzU0MjkgcywgMTUuMCBNQi9zCit0
cmllZCB0byB3cml0ZSAzbSB3b3J0aCBkYXRhCisKLS0gCjEuOC4xLjIKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
