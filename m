Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA8117F37
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 17:27:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8897304039
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 15:27:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Zsb1zvwVLFPUibNY for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 15:27:01 -0700 (PDT)
Message-ID: <544AD234.3060100@sandeen.net>
Date: Fri, 24 Oct 2014 17:27:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com>
	<544AB338.2050905@sandeen.net>	<544ACDC4.1070501@hardwarefreak.com>
	<544AD077.4080305@sandeen.net>
In-Reply-To: <544AD077.4080305@sandeen.net>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 10/24/14 5:19 PM, Eric Sandeen wrote:
> On 10/24/14 5:08 PM, Stan Hoeppner wrote:
>>
>> On 10/24/2014 03:14 PM, Eric Sandeen wrote:
> 
> ...
> 
>>>> Any ideas how to verify what's going on here and fix it?
>>>
>>> # blockdev --getiomin --getioopt /dev/s2d_a1l003

Also, what does it show for the underlying non-multipath device(s)?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
