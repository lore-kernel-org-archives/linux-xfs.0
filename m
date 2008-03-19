Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 09:54:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JGsbE4019874
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 09:54:43 -0700
Received: from relay-cv.club-internet.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B643DFC3B83
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 09:55:10 -0700 (PDT)
Received: from relay-cv.club-internet.fr (relay-cv.club-internet.fr [194.158.96.103]) by cuda.sgi.com with ESMTP id GnF9LImNXDIuXiO4 for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 09:55:10 -0700 (PDT)
Received: from petole.dyndns.org (i07v-62-34-16-56.d4.club-internet.fr [62.34.16.56])
	by relay-cv.club-internet.fr (Postfix) with ESMTP id 2D86D25610
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 17:54:34 +0100 (CET)
From: Nicolas KOWALSKI <niko@petole.dyndns.org>
Subject: xfsdump debian package, wrong version number
Date: Wed, 19 Mar 2008 17:54:45 +0100
Message-ID: <87iqzi3b8q.fsf@petole.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I just downloaded the lastest cmd_tars from
ftp://oss.sgi.com/projects/xfs/cmd_tars/, and built the xfsdump
package for Debian (etch). No problems.

However, the generated package seems to have the wrong version number,
2.2.45 instead of the expected 2.2.48. Apparently the debian/changelog
file does not have the correct information.

Regards,
-- 
Nicolas
