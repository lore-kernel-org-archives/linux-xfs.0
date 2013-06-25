Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10C657F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 01:45:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2AED304032
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 23:45:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5ehEUGm8Iydo9Wz7 for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 23:45:25 -0700 (PDT)
Date: Tue, 25 Jun 2013 16:45:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 6/6] xfs: Use new qs_pquota field in fs_quota_stat for
	Q_XGETQSTAT
Message-ID: <20130625064505.GW29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-7-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372042107-27332-7-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Sun, Jun 23, 2013 at 09:48:27PM -0500, Chandra Seetharaman wrote:
> For the Q_XGETQSTAT quota command, if the new version of fs_quota_stat
> data structure is used, fill the project quota information.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
