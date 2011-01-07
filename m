Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07EJXXP065348 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 08:19:33 -0600
Received: from mail-pv0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 583AB1D166BE
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 06:21:42 -0800 (PST)
Received: from mail-pv0-f181.google.com (mail-pv0-f181.google.com
	[74.125.83.181]) by cuda.sgi.com with ESMTP id Uva1RD856haEQDAp
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 06:21:42 -0800 (PST)
Received: by pvg12 with SMTP id 12so4730570pvg.26
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 06:21:42 -0800 (PST)
Message-ID: <4D272171.9090906@philkarn.net>
Date: Fri, 07 Jan 2011 06:21:37 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: TRIM details
References: <4D2686ED.7000304@philkarn.net> <20110107091120.GA6634@citd.de>
In-Reply-To: <20110107091120.GA6634@citd.de>
Reply-To: karn@ka9q.net
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: karn@ka9q.net, xfs@oss.sgi.com

On 1/7/11 1:11 AM, Matthias Schniedermeyer wrote:

> "Quite fast" is something of an understatement.
> The Intel SSD can TRIM the whole drive in a matter of seconds. I have 
> tested that with hdparm, when i wrote me a simple disc imaging 
> perl-script.

Yes, I've been running wiper.sh on the XFS filesystems on my Intel 120
GB SSD and it's impressively fast. I've been careful to do backups
first, but I haven't had a problem yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
