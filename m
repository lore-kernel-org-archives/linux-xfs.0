Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KF0LOd102095 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:00:31 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55EAB14F4771
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:01:03 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.148])
	by cuda.sgi.com with ESMTP id Exf9rJwhUH23so8o for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:01:03 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 5so1637609qwf.32
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:00:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Aug 2009 11:00:57 -0400
Message-ID: <a0531a500908200800m3f5ea065v818c97e845042221@mail.gmail.com>
Subject: XFS Best Practices
From: Jeff Flowers <ragepie@gmail.com>
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

I am going to use XFS on a Arch Linux box and I am looking for ways to
maximize XFS performance. According to an article I have read [1],
best XFS performance was reached with a file system formatted with a
64MB log and mounted with 8 log buffers and atime disabled. But I am
curious, from the prespective of the XFS experts of this list, if this
is still good advice and if it is still relevant, as this article was
published in 2003.

Also, I have seen a few people recommend turning off the internal
buffers of hard drives (via hdparm) when using a file system like XFS.
Good advice?



Thank you!

-- 
[1] http://everything2.com/title/Filesystem+performance+tweaking+with+XFS+on+Linux

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
