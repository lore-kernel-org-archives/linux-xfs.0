Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38DC97F85
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 02:33:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17D4030404E
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 00:33:56 -0700 (PDT)
Received: from mailly.debian.org (mailly.debian.org [82.195.75.114]) by
	cuda.sgi.com with ESMTP id 2hajtN4ZLnA4KZfx (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 00:33:54 -0700 (PDT)
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
MIME-Version: 1.0
Subject: xfsprogs_3.2.4-1_i386.changes ACCEPTED into unstable
Message-Id: <E1ZNFgV-0003Kq-4b@franck.debian.org>
Date: Thu, 06 Aug 2015 07:33:51 +0000
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS Development Team <xfs@oss.sgi.com>, Nathan Scott <nathans@debian.org>



Accepted:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Thu, 06 Aug 2015 16:26:57 +1000
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source i386
Version: 3.2.4-1
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <xfs@oss.sgi.com>
Changed-By: Nathan Scott <nathans@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Changes:
 xfsprogs (3.2.4-1) unstable; urgency=low
 .
   * New upstream release
   * Fix xfs_metadump information leak (CVE-2012-2150)
Checksums-Sha1:
 937683ee5db2a6627127b89c7dbc59af4e2dd989 1788 xfsprogs_3.2.4-1.dsc
 38a876cc06284b3e7e514629a243d2a8b9300b35 1505783 xfsprogs_3.2.4-1.tar.gz
 f975db7beff25c854c84544ae7fc9c07c5410140 31772 xfslibs-dev_3.2.4-1_i386.deb
 c3ae8694bd59db51155bfc9e5dcf7018fdbd5dae 145960 xfsprogs-udeb_3.2.4-1_i386.udeb
 30671bc8addb9956950ee5ef68993ae1f0af493d 727256 xfsprogs_3.2.4-1_i386.deb
Checksums-Sha256:
 5e16f102e689d42e1afca2cdee30248e8420625abc5665f676eb3168ad4cb77e 1788 xfsprogs_3.2.4-1.dsc
 659b61b93bfa0aabed05d0e961ce13bab200110126d9c14ed8915f5bacfb0456 1505783 xfsprogs_3.2.4-1.tar.gz
 392d0fa1ee14a3e87ddf711fcd3e7a8066b302d51cd27460267974fdcd43abea 31772 xfslibs-dev_3.2.4-1_i386.deb
 7fee9076cf9ecddef0202bdf4af840994f2025bdb77fc78a63f55f32a90675e2 145960 xfsprogs-udeb_3.2.4-1_i386.udeb
 8266738d86d7f635a5d7ae7cf9d43d707aa33f4fddfb55ca1f062690d67e51bb 727256 xfsprogs_3.2.4-1_i386.deb
Files:
 21ec1c7c38f74c36d7a490438803092b 1788 admin optional xfsprogs_3.2.4-1.dsc
 418b0b5378ef37e98a9d4b51b66e2a94 1505783 admin optional xfsprogs_3.2.4-1.tar.gz
 bfd935b574ac1cdca54a214928dd7a19 31772 libdevel extra xfslibs-dev_3.2.4-1_i386.deb
 91fc35043652ca36ab86afe4e0fdceb2 145960 debian-installer optional xfsprogs-udeb_3.2.4-1_i386.udeb
 ec93b29dc21dec70c6a9e243e7191b67 727256 admin optional xfsprogs_3.2.4-1_i386.deb
Package-Type: udeb

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJVwwAfAAoJEP4IQu423YwMmwcP/0zfcSgDK1VDf8+VobfBYaYQ
sES2lFzDutwz39OqDw9g0wlyID+vvZi6R6j3PIw4qC0lBYTNmD34xLAc/Iyo9vgF
GAQVhoenFml6cDju8bL98Etn8UbFN65DUI0+UJb9Xe0/bI9qg/aeoL6jiexOlUjk
RsKuiQDVhqVnNxlrf+Dxm7Pa7IIMhcWE8uGFuSOo5Cx7EgaxAS8oI4UnWl6ITM9H
AYtlEszlPAMmxQ3MgFrXGc58IVovfO+WLWJO19WIY+BZpWQMu5JR7r0La6tdVl/R
WXNop1Ou8NvUOAPkmXCCtbRjRMjTtl+pTOfQ6tdEHa5iSaxh6LBVhdauGRnI1GYF
iVBc6bmOcSCe1Q+8oSe9b8s7MAZqN1/wgnE7SlIhdjsgPzY+JbYYe42qE/WLrmzu
/5RSdDwblMdkzqJdwgXf25gbH7/tq70eVoe3qR4LxuoZdsSL+Re4y5CVzWJ0pT6V
kv59RrJRlPs802SAZh/Y2T8XwqGcR0i1LNZZClS4223igsvyZPuP6eWDDp4/Z9Xy
Af/+5NGe/GKFeocOUFNaXPa5VyU8pF/aTHHSoIe95FxnxZjAaDUpQoT2bfe8RyCE
xMPlPd08/YicPy7UxJiJtby9j5g/1jvrxgIVqETv27tkUjeMFHIjx7w/VftUSd7b
7ibJwLY3EGNcUKkr9rX0
=bkI6
-----END PGP SIGNATURE-----


Thank you for your contribution to Debian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
