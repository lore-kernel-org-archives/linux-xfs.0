Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86F5F7F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 06:02:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71539304039
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 04:02:25 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qMEKLuWDH9g1wfLV
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 04:02:24 -0700 (PDT)
Message-ID: <513DB9C2.3050408@hardwarefreak.com>
Date: Mon, 11 Mar 2013 06:02:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Maximum file system size of XFS?
References: <20130309215121.0e614ef8@thinky> <513BB7C3.4050009@redhat.com>
	<20130309233940.3b7c0910@thinky> <513BDD6E.7010507@sandeen.net>
	<513C3C43.7080104@hardwarefreak.com>
In-Reply-To: <513C3C43.7080104@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Pascal <pa5ca1@gmx.de>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 3/10/2013 1:54 AM, Stan Hoeppner wrote:

> So in summary, an Exabyte scale XFS is simply not practical today, and
> won't be for at least another couple of decades, or more, if ever.  The
> same holds true for some of the other filesystems you're going to be
> writing about.  Some of the cluster and/or distributed filesystems
> you're looking at could probably scale to Exabytes today.  That is, if
> someone had the budget for half a million hard drives, host systems,
> switches, etc, the facilities to house it all, and the budget for power
> and cooling.  That's 834 racks for drives alone, just under 1/3rd of a
> mile long if installed in a single row.

Jet lag due to time travel caused a math error above.  With today's 4TB
drives it would require 2.25 million units for a raw 9EB capacity.
That's 3,750 racks of 600 drives each.  These would stretch 1.42 miles,
7500 ft.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
