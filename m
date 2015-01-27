Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E6717FA6
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 13:15:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5DAE58F807A
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 11:15:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FgDRVPuND6sglKgw for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 11:15:27 -0800 (PST)
Message-ID: <54C7E3CE.1050102@sandeen.net>
Date: Tue, 27 Jan 2015 13:15:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: maxpct option for small xfs filesystems
References: <54C667F3.8040303@oracle.com>
	<20150126223715.GA7621@dastard>	<54C7BB78.4060203@oracle.com>
	<54C7BD60.5000104@sandeen.net>
In-Reply-To: <54C7BD60.5000104@sandeen.net>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 1/27/15 10:31 AM, Eric Sandeen wrote:

> This is actually a problem with the lazy superblock counters I've run into before,
> but haven't yet fixed.  This kind of workload is such that it never trips the
> runtime rebalancing.

working on a fix now ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
