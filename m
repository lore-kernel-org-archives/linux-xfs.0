Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D209429E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 09:56:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 589FFAC008
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:56:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pnmrBsoE4x3qQNlS for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 07:56:46 -0800 (PST)
Message-ID: <528A38BA.9020405@sandeen.net>
Date: Mon, 18 Nov 2013 09:56:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfsprogs: suggest "-d" option for repair of RO mount
References: <528261AD.50501@redhat.com>	<20131113125921.GC24615@orion.maiolino.org>	<52851CA9.8080903@sandeen.net>
	<20131117195614.GU6188@dastard>
In-Reply-To: <20131117195614.GU6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/17/13, 1:56 PM, Dave Chinner wrote:

<snip>

> Right, so let's make sure we don't give people any impression it is
> safe :)
> 
>>>> +_("Unmount or use -d to repair a read-only mounted filesystem\n"));
> 
> _("Unmount or use the dangerous (-d) option to repair a read-only mounted filesystem\n"));

Good idea, will send V2.
 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
