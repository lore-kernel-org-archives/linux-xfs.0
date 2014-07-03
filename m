Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D7ED37F37
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 08:50:46 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D158F8F8035
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 06:50:43 -0700 (PDT)
Received: from [128.162.232.11] (porter.americas.sgi.com [128.162.232.11])
	by estes.americas.sgi.com (Postfix) with ESMTP id 8450F7001893
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 08:50:43 -0500 (CDT)
Message-ID: <53B55FB3.10804@sgi.com>
Date: Thu, 03 Jul 2014 08:50:43 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS Realtime Replication problem
References: <53B4E20C.60602@cmcltd.com>
	<20140703061525.GF9508@dastard>	<53B4F7B7.4080807@cmcltd.com>
	<20140703090253.GT4453@dastard> <53B52098.2090104@cmcltd.com>
In-Reply-To: <53B52098.2090104@cmcltd.com>
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
To: xfs@oss.sgi.com

On 07/03/2014 04:21 AM, Jignesh wrote:
> Dear Dave,
>
> Thanks for your reply.
>
> Regards,
>
> Jignesh P.
>
> On 03-07-2014 14:32, Dave Chinner wrote:
>> On Thu, Jul 03, 2014 at 11:57:03AM +0530, Jignesh wrote:
>>> Dear Dave,
>>>
>>> Thanks for your quick response.
>>>
>>> This is not SGI Proprietary Storage product and not using any SGI
>>> proprietary kernel module. SGI IS3500 is normal Intel Server with 36
>>> HDDs. ( Storage Server), We have installed RHEL 6.2 on this Server
>>> and configured XVM and XFS.
>> XVM is SGI proprietary software:
>>
>> http://www.sgi.com/products/storage/software/xvm.html
>>
>> As it is, if you are using RHEL, you should talk to your Red Hat
>> support contact. They'll be able to tell you if it's a known problem
>> w/ XFS on RHEL and which version of RHEL 6.x it is fixed in.
>>
>> Cheers,
>>
>> Dave.

Jignesh,

If you have SGI XVM installed, then you most likely have the SGI 
supplied version
of XFS installed as well.

If you do have the SGI supplied version of XFS installed, Red Hat 
support will redirect you
to SGI for support.

Thanks,
Troy McCorkell



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
