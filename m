Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GGFn1G129570 for <xfs@oss.sgi.com>; Sat, 16 May 2009 11:15:49 -0500
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DC631484A0C
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 09:20:53 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.149])
	by cuda.sgi.com with ESMTP id 7K0wJco2iDTkvX9B for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 09:20:53 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 4so642398eyg.32
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 09:15:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 May 2009 12:15:54 -0400
Message-ID: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
Subject: quick question about filename length
From: Chris Walker <christopher.walker@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I see that
#define MAXNAMELEN  256

Is this the maximum length of the filename with full path?  Or is this
just the name of the file?

Many thanks!
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
