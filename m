Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C70937F54
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 17:59:28 -0600 (CST)
Message-ID: <51119CE3.6020409@sgi.com>
Date: Tue, 05 Feb 2013 17:59:31 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs deadlock on buffer semaphore while reading directory
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com>
	<20130202204601.GT30577@one.firstfloor.org>
In-Reply-To: <20130202204601.GT30577@one.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On 02/02/13 14:46, Andi Kleen wrote:
>> That looks like a hang fixed by the series:
>>
>> 	http://oss.sgi.com/archives/xfs/2012-12/msg00071.html
>
> Great that it is already fixed. Thanks.
>
> Is the fix considered for stable?
>
> -Andi
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Thanks for the reminder.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
