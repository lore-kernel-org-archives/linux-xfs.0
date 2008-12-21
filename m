Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLKre77016342 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 14:53:40 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6E913C59E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 12:53:38 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Hb85xNNhKlgPegXc for
	<xfs@oss.sgi.com>; Sun, 21 Dec 2008 12:53:38 -0800 (PST)
Date: Sun, 21 Dec 2008 15:53:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Big filesystem > (4TiB) recommendations (mkfs parameter tuning?)
Message-ID: <alpine.DEB.1.10.0812211551170.24116@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Often, on this list, there are issues where there is not enough memory, 
etc, to repair a large filesystem.

If one is going to create a 10-16TiB filesystem (for example), should one 
use the mkfs.xfs defaults, or should there be special tuning for 
filesystems of this size, so they will be less susceptible to failure for 
one reason or another?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
