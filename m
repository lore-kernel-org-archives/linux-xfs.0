Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7HI4k5n086263 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 13:04:56 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7927A1BD9FC9
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 11:05:01 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id C6gc1Yu5Shyzk4oB for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 11:05:01 -0700 (PDT)
Received: from jquigley.cleversafe.org (67-129-215-3.dia.static.qwest.net
	[67.129.215.3]) (Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 05268204118
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 18:04:57 +0000 (UTC)
Message-ID: <4A899BC9.6070604@jquigley.com>
Date: Mon, 17 Aug 2009 13:04:57 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <1851101658.1934521250210319746.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1851101658.1934521250210319746.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: XFS Development <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> If that fails too can you run xfs_logprint on /dev/sde and
> post any errors it reports?

My apologies for the delayed response; output of logprint can be downloaded as a ~4MB bzip:

http://www.jquigley.com/files/tmp/xfs-failover-logprint.bz2

Thanks very much for your consideration.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
