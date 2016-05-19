Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 750F87CA0
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 09:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4708F304032
	for <xfs@oss.sgi.com>; Thu, 19 May 2016 07:39:09 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id CPIVVYCqQCKlvwB6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 May 2016 07:39:07 -0700 (PDT)
Subject: Bug#822369: fixed in qemu 1:2.6+dfsg-1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.822369.B822369.146366865731948@bugs.debian.org>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <573DCFAA.8000500@physik.fu-berlin.de>
Date: Thu, 19 May 2016 16:37:30 +0200
MIME-Version: 1.0
Reply-To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	822369@bugs.debian.org
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 822369@bugs.debian.org

Control: reopen -1

Hi Michael!

You closed a bug in src:xfsprogs with a new version of qemu, I don't
think this is correct and this bug should therefore be reopened.

While qemu doesn't seem to be affected by this particular issue anymore,
I don't think the bug in src:xfsprogs itself has been fixed since there
hasn't been a new upload of xfsprogs since February.

Please be more careful when handling of bug reports!

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
