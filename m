Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19AE37F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 13:06:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 261D98F8033
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 11:06:00 -0700 (PDT)
Received: from mail3.ks.pochta.ru (mail3.ks.pochta.ru [62.141.94.173]) by
	cuda.sgi.com with ESMTP id BwxE8UlmFHMg5m5J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 11:05:58 -0700 (PDT)
Received: from [95.79.188.197] (port=58170 helo=localhost.localdomain)
	by mail3.ks.pochta.ru with esmtpsa id 1X2lOO-0002Xj-9U
	for xfs@oss.sgi.com; Thu, 03 Jul 2014 22:05:56 +0400
Message-ID: <53B59B81.2030603@hotbox.ru>
Date: Thu, 03 Jul 2014 22:05:53 +0400
From: flux@hotbox.ru
MIME-Version: 1.0
Subject: XFS syncs
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I issue 'mkdir abc' on my xfs partition the cut off the power. After 
reboot there's no 'abc' directoy. However, when I do that on ext4 the 
'abc' direcory is always created after reboots. All the settings, about 
mount options are default for my distro. What am I missing or how do I 
change the things of the jounral or whatever?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
