Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10EC37F61
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 00:25:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12E15304039
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 22:25:52 -0700 (PDT)
Received: from mx1.securemx.in (mx1.securemx.in [121.241.247.20]) by
	cuda.sgi.com with ESMTP id x21iVHfHqwYzOLni (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Jul 2014 22:25:49 -0700 (PDT)
Message-ID: <53B4E952.7020009@cmcltd.com>
Date: Thu, 03 Jul 2014 10:55:38 +0530
From: Jignesh <jignesh.prajapati@cmcltd.com>
MIME-Version: 1.0
Subject: Re: XFS Realtime Replication problem
References: <53B4E20C.60602@cmcltd.com>
In-Reply-To: <53B4E20C.60602@cmcltd.com>
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
Cc: "Bhavin.Joshi@Cmcltd.Com" <bhavin.joshi@cmcltd.com>, "Gaurang.Patel@Cmcltd.Com" <gaurang.patel@cmcltd.com>, Ravi <m.ravindran@cmcltd.com>

One thing I want to update that the same Realtime Replication works fine 
with ext4 Filesystem.

Regards,

Jignesh P.

On 03-07-2014 10:24, Jignesh wrote:
> Dear,
>
> We have SGI IS3500 Storage server and we have installed RHEL 6.2 with 
> XVM and XFS. We have installed CA ARCserve Replication host based 
> realtime replication software for Realtime byte level replications to 
> other server in network for DR.
>
> Now we are facing one problem that at the time of Realtime replication 
> if we update any file on Master (Source) server, file size becomes 0 
> byte in master server the same file content becomes garbage and slave 
> side also file size becomes 0 size.
>
> Please help, we are struggling from last one month.
>
> With warm Regards,
>
>
> Jignesh Prajapati
> Sr. IT Manager-CS
> CMC Limited
> (A TATA Enterprise)
> 6th Floor, Premier House-1, Bodakdev, S G Highway, Ahmedabad-380054
> Direct Line: +91 79 66090924 | Email: jignesh.prajapati@cmcltd.com
> www.cmcltd.com
> ---------------------------------------------------------------------------------------------------------- 
>
> System Engineering | Integration | Solution & Sales
> ---------------------------------------------------------------------------------------------------------- 
>
>


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
