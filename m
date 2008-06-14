Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 12:40:26 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EJeKij006588
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:40:20 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDB4417C6036
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:41:15 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157]) by cuda.sgi.com with ESMTP id 13ujCbF8xvgPbolB for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:41:15 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so3169346fgb.8
        for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 12:41:15 -0700 (PDT)
Message-ID: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
Date: Sat, 14 Jun 2008 21:41:12 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wright <chrisw@sous-sol.org>, Christoph Hellwig <hch@infradead.org>, stable@kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, Konstantin Kletschke <lists@ku-gbr.de>

http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00776.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00777.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00778.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00779.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00780.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00781.jpg

tainted with: nvidia and madwifi
kernel: 2.6.25.6 + queue patches (queue head on
aa8edcb997ff605bd1424630356866b78ef06cdc)

-- 
Thanks,
Oliver
