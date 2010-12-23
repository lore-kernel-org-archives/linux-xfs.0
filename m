Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNNkc33015437 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 17:46:39 -0600
Received: from smtp3.clear.net.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0488E147EB4F
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:48:36 -0800 (PST)
Received: from smtp3.clear.net.nz (smtp3.clear.net.nz [203.97.33.64]) by
	cuda.sgi.com with ESMTP id bH6F0ySMlUOIrtTe for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:48:36 -0800 (PST)
Received: from [210.246.8.113] (210-246-8-113.paradise.net.nz [210.246.8.113])
	by smtp3.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0LDW00F8ZNGZW900@smtp3.clear.net.nz> for xfs@oss.sgi.com;
	Fri, 24 Dec 2010 12:48:36 +1300 (NZDT)
Date: Fri, 24 Dec 2010 12:47:42 +1300
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: able to mount a fs, unable to repair it
Message-id: <4D13DF9E.4090507@clear.net.nz>
MIME-version: 1.0
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

Emmanuel Florac wrote:

 > However, a reliable RAID-5 is probably safer than an experimental
 > RAID-6 overall.

Looking at the 2.6.29.1 kernel running on this machine, the only md RAID 
mode marked as experimental is RAID-10.

I have no experience using Xen, but have used md RAID6 extensively in 
heavily loaded situations for over three years without problems.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
