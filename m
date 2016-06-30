Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C10A7CA4
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 11:11:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C543BAC00A
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 09:11:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 14oTVH6FuhgLaDq9 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 09:11:15 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 16491142F
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 11:11:15 -0500 (CDT)
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
Date: Thu, 30 Jun 2016 11:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
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
To: xfs@oss.sgi.com



On 6/30/16 10:35 AM, Anthony l wrote:
> Thanks for replying. I made a Paste bin of the output I'm getting.
> This time I used the -K option which is to force use compatibility
> with older versions of xfs I think.
> 
> http://pastebin.com/vrL6iiW2
> 
> 
> 
> There is my full output to what I am getting. Not actually getting an
> error code I just don't understand why this wouldn't work. Also If I
> chose skip instead of restore ill get to some different dumps. But
> same thing happens if I choose restore on those too.

You might also look at

http://oss.sgi.com/archives/xfs/2005-01/msg00418.html

and try another run with maximum verbosity as that user 
did.

Is this a multi-tape dump?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
