Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SNgRwZ028343 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:42:27 -0500
Received: from nospam5.slac.stanford.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB7F311B4CB8
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:46:00 -0700 (PDT)
Received: from nospam5.slac.stanford.edu (nospam5.slac.stanford.edu
	[134.79.18.83]) by cuda.sgi.com with ESMTP id sDfqweWGjeSXNB0v
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:46:00 -0700 (PDT)
Received: from mailgate05.slac.stanford.edu (mailgate05.slac.stanford.edu
	[134.79.18.85])
	by nospam5.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id
	p3SNk0Id008561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:46:00 -0700
	(envelope-from ling@slac.stanford.edu)
Received: from [134.79.165.22] (psdev102.slac.stanford.edu [134.79.165.22])
	by mailgate05.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id
	p3SNjxsq019122
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:45:59 -0700 (PDT)
	(envelope-from ling@slac.stanford.edu)
Message-ID: <4DB9FC37.8080904@slac.stanford.edu>
Date: Thu, 28 Apr 2011 16:45:59 -0700
From: Ling Ho <ling@slac.stanford.edu>
MIME-Version: 1.0
Subject: convert External Log to Internal Log
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

Is there any way to convert from external log to internal log on RHEL 5.6?

I tried running xfs_growfs -i but it complains saying

xfs_growfs: failed to access external log for /dev/sdc

and the man page says -i is not implemented. I am using xfsprogs version 
3.1.5.

Thanks,
...
ling

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
