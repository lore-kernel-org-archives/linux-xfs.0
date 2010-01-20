Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KEn5Tu014426 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 08:49:05 -0600
Received: from mail-ew0-f222.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0939C17AAE6
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 06:50:05 -0800 (PST)
Received: from mail-ew0-f222.google.com (mail-ew0-f222.google.com
	[209.85.219.222]) by cuda.sgi.com with ESMTP id
	TEySxDdAUwuyENv8 for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 06:50:05 -0800 (PST)
Received: by ewy22 with SMTP id 22so6151889ewy.19
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 06:50:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9cf823c61001200629x5be69ea3t6fca943a9b0844f3@mail.gmail.com>
References: <4B5578E0.5000201@gmail.com>
	<1067945374.1918531263959691412.JavaMail.root@mail-au.aconex.com>
	<9cf823c61001200629x5be69ea3t6fca943a9b0844f3@mail.gmail.com>
Date: Wed, 20 Jan 2010 09:50:04 -0500
Message-ID: <9cf823c61001200650w3fc7502fi13cd828bb2d8d3d5@mail.gmail.com>
Subject: Re: acl build failure on x86_64
From: Jon Grosshart <jgrosshart@gmail.com>
Content-Type: multipart/mixed; boundary=0016e6d77e32a4a64a047d99b3b3
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--0016e6d77e32a4a64a047d99b3b3
Content-Type: text/plain; charset=ISO-8859-1

Also, on a side note, would be nice from a packagers stand point to
have the attached DESTDIR patch applied to both acl and attr......

Thanks again Nathan.

--0016e6d77e32a4a64a047d99b3b3
Content-Type: application/octet-stream; name="acl-destdir.patch"
Content-Disposition: attachment; filename="acl-destdir.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4oiztkl0

ZGlmZiAtdXJOIGFjbC0yLjIuNDktb3JpZy9pbmNsdWRlL2J1aWxkZGVmcy5pbiBhY2wtMi4yLjQ5
L2luY2x1ZGUvYnVpbGRkZWZzLmluCi0tLSBhY2wtMi4yLjQ5LW9yaWcvaW5jbHVkZS9idWlsZGRl
ZnMuaW4JMjAwOS0wNi0yMiAxNDozNzozMS4wMDAwMDAwMDAgLTA0MDAKKysrIGFjbC0yLjIuNDkv
aW5jbHVkZS9idWlsZGRlZnMuaW4JMjAxMC0wMS0yMCAwOTo0NDoxMy4wMDAwMDAwMDAgLTA1MDAK
QEAgLTI4LDE0ICsyOCwxNCBAQAogUEtHX1ZFUlNJT04JPSBAcGtnX3ZlcnNpb25ACiBQS0dfUExB
VEZPUk0JPSBAcGtnX3BsYXRmb3JtQAogUEtHX0RJU1RSSUJVVElPTj0gQHBrZ19kaXN0cmlidXRp
b25ACi1QS0dfQklOX0RJUgk9IEBiaW5kaXJACi1QS0dfU0JJTl9ESVIJPSBAc2JpbmRpckAKLVBL
R19MSUJfRElSCT0gQGxpYmRpckBAbGliZGlyc3VmZml4QAotUEtHX0RFVkxJQl9ESVIJPSBAbGli
ZXhlY2RpckBAbGliZGlyc3VmZml4QAotUEtHX0lOQ19ESVIJPSBAaW5jbHVkZWRpckAKLVBLR19N
QU5fRElSCT0gQG1hbmRpckAKLVBLR19ET0NfRElSCT0gQGRhdGFkaXJAL2RvYy9AcGtnX25hbWVA
Ci1QS0dfTE9DQUxFX0RJUgk9IEBkYXRhZGlyQC9sb2NhbGUKK1BLR19CSU5fRElSCT0gJChERVNU
RElSKUBiaW5kaXJACitQS0dfU0JJTl9ESVIJPSAkKERFU1RESVIpQHNiaW5kaXJACitQS0dfTElC
X0RJUgk9ICQoREVTVERJUilAbGliZGlyQEBsaWJkaXJzdWZmaXhACitQS0dfREVWTElCX0RJUgk9
ICQoREVTVERJUilAbGliZXhlY2RpckBAbGliZGlyc3VmZml4QAorUEtHX0lOQ19ESVIJPSAkKERF
U1RESVIpQGluY2x1ZGVkaXJACitQS0dfTUFOX0RJUgk9ICQoREVTVERJUilAbWFuZGlyQAorUEtH
X0RPQ19ESVIJPSAkKERFU1RESVIpQGRhdGFkaXJAL2RvYy9AcGtnX25hbWVACitQS0dfTE9DQUxF
X0RJUgk9ICQoREVTVERJUilAZGF0YWRpckAvbG9jYWxlCiAKIENDCQk9IEBjY0AKIEFXSwkJPSBA
YXdrQApkaWZmIC11ck4gYWNsLTIuMi40OS1vcmlnL2luY2x1ZGUvYnVpbGRtYWNyb3MgYWNsLTIu
Mi40OS9pbmNsdWRlL2J1aWxkbWFjcm9zCi0tLSBhY2wtMi4yLjQ5LW9yaWcvaW5jbHVkZS9idWls
ZG1hY3JvcwkyMDA5LTA2LTIyIDE0OjM3OjMxLjAwMDAwMDAwMCAtMDQwMAorKysgYWNsLTIuMi40
OS9pbmNsdWRlL2J1aWxkbWFjcm9zCTIwMTAtMDEtMjAgMDk6NDI6MjEuMDAwMDAwMDAwIC0wNTAw
CkBAIC00MCw3ICs0MCw3IEBACiAJICAkKExGSUxFUzoubD0ubykgXAogCSAgJChZRklMRVM6JS55
PSUudGFiLm8pCiAKLUlOU1RBTEwJPSAkKFRPUERJUikvaW5jbHVkZS9pbnN0YWxsLXNoIC1vICQo
UEtHX1VTRVIpIC1nICQoUEtHX0dST1VQKQorSU5TVEFMTAk9ICQoVE9QRElSKS9pbmNsdWRlL2lu
c3RhbGwtc2ggCiAKIFNIRUxMID0gL2Jpbi9zaAogSU1BR0VTX0RJUiA9ICQoVE9QRElSKS9hbGwt
aW1hZ2VzCg==
--0016e6d77e32a4a64a047d99b3b3
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--0016e6d77e32a4a64a047d99b3b3--
