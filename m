Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3U7gOwT214998 for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 02:42:24 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 03E6D24FD3B
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 00:42:23 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id Bzk818HoHK4RQifc for
	<xfs@oss.sgi.com>; Thu, 30 Apr 2009 00:42:23 -0700 (PDT)
Message-ID: <49F9565E.40804@gslab.com>
Date: Thu, 30 Apr 2009 13:12:22 +0530
From: Milind Dumbare <milind@gslab.com>
MIME-Version: 1.0
Subject: EXT vs XFS at 80% filled filesystem
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
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

Hi,

I have heard of XFS's performance is not good as compared to EXT3 when 
the filesystem(disk) is 80% filled with data. Is it true? I have went 
through lots of performance documents of both XFS and EXT3 but could not 
find such performance benchmarking (for 80% full filesystems).

Any numbers or pointers to other documents are appreciated.

Thanks
-Miline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
