Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA3BD7F57
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 01:27:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24A05AC001
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 23:27:18 -0700 (PDT)
Received: from mx1.securemx.in (mx1.securemx.in [121.241.247.20]) by
	cuda.sgi.com with ESMTP id N5m1EYU8znjA1z5k (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Jul 2014 23:27:15 -0700 (PDT)
Message-ID: <53B4F7B7.4080807@cmcltd.com>
Date: Thu, 03 Jul 2014 11:57:03 +0530
From: Jignesh <jignesh.prajapati@cmcltd.com>
MIME-Version: 1.0
Subject: Re: XFS Realtime Replication problem
References: <53B4E20C.60602@cmcltd.com> <20140703061525.GF9508@dastard>
In-Reply-To: <20140703061525.GF9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: "Bhavin.Joshi@Cmcltd.Com" <bhavin.joshi@cmcltd.com>, "Gaurang.Patel@Cmcltd.Com" <gaurang.patel@cmcltd.com>, Ravi <m.ravindran@cmcltd.com>

Dear Dave,

Thanks for your quick response.

This is not SGI Proprietary Storage product and not using any SGI 
proprietary kernel module. SGI IS3500 is normal Intel Server with 36 
HDDs. ( Storage Server), We have installed RHEL 6.2 on this Server and 
configured XVM and XFS.

Regards,

Jignesh P.

On 03-07-2014 11:45, Dave Chinner wrote:
> On Thu, Jul 03, 2014 at 10:24:36AM +0530, Jignesh wrote:
>> Dear,
>>
>> We have SGI IS3500 Storage server and we have installed RHEL 6.2
>> with XVM and XFS. We have installed CA ARCserve Replication host
>> based realtime replication software for Realtime byte level
>> replications to other server in network for DR.
> SGI storage product, SGI proprietary kernel modules - you probably
> should be sending email to your SGI support contact, not to the
> public upstream XFS development list....
>
> Cheers,
>
> Dave.


-- 
Jignesh Prajapati
Sr. IT Manager-CS
CMC Limited
(A TATA Enterprise)
6th Floor, Premier House-1, Bodakdev, S G Highway, Ahmedabad-380054
Direct Line: +91 79 66090924 | Email: jignesh.prajapati@cmcltd.com
www.cmcltd.com
----------------------------------------------------------------------------------------------------------
System Engineering | Integration | Solution & Sales
----------------------------------------------------------------------------------------------------------

______________________________________________________________________________

DISCLAIMER

The information contained in this e-mail message and/or attachments to it may
contain confidential or privileged information. If you are not the intended
recipient, any dissemination, use, review, distribution, printing or copying
of the information contained in this e-mail message and/or attachments to it
are strictly prohibited. If you have received this communication in error,
please notify us by reply e-mail or directly to netsupport@cmcltd.com or
telephone and immediately and permanently delete the message and any
attachments. Thank you.

______________________________________________________________________________

This email has been scrubbed for your protection by SecureMX.
For more information visit http://securemx.in
_____________________________________________________________________________

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
