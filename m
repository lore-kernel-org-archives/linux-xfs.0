Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1QKSs23207199 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 14:28:54 -0600
Received: from aspensprings.uwyo.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D332B1D01292
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 12:30:18 -0800 (PST)
Received: from aspensprings.uwyo.edu (aspensprings.uwyo.edu [129.72.10.32]) by
	cuda.sgi.com with ESMTP id 8rJjxuLx4BUjwSaQ for
	<xfs@oss.sgi.com>; Fri, 26 Feb 2010 12:30:18 -0800 (PST)
Received: from ponyexpress-ht1.uwyo.edu (ponyexpress-ht1.uwyo.edu
	[10.84.60.208])
	by aspensprings.uwyo.edu (8.14.2/8.14.2) with ESMTP id o1QKUCvY018962
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 13:30:13 -0700 (MST)
	(envelope-from Fletcher@uwyo.edu)
Message-ID: <4B882F5D.5090901@uwyo.edu>
Date: Fri, 26 Feb 2010 13:30:21 -0700
From: "Walter R. Fletcher" <fletcher@uwyo.edu>
MIME-Version: 1.0
Subject: 4k sector sizes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Western Digital has announced hard drives that will
have 4K sized sectors instead of 512 bytes.  I'm sure
other manufacturers will do so too...

I wonder about potential effects on performance one
might see re: xfs with a 4k block size and the WD hard
drives with the 4k sectors.  Is this a valid question?

Just a curious (xfs-using) fly on the wall...

__Reid__

Reid Fletcher
Chief Engineer, Wyoming Public Radio
University of Wyoming
Laramie, WY

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
