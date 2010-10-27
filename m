Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9RALSNE157435 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 05:21:28 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 798751295BB
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:22:45 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id ZCKuenP8WGnx8MhU
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:22:45 -0700 (PDT)
Message-ID: <4CC7FD77.7030706@profihost.ag>
Date: Wed, 27 Oct 2010 12:22:47 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>
	<4CC6B56B.7020007@profihost.ag>	<20101026132505.6af29d5d@harpe.intellique.com>	<201010270124.44846@zmi.at>	<20101027080454.31a59a3c@galadriel.home>	<4CC7CDF6.3080405@profihost.ag>	<20101027120628.7b4b2e20@harpe.intellique.com>	<4CC7FA39.4030502@profihost.ag>
	<20101027121240.4e8ca83a@harpe.intellique.com>
In-Reply-To: <20101027121240.4e8ca83a@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

 > Yes, the initiator values are more important here. Basically, the
 > iscsitarget service should transmit the initiator's requests as they
 > come.
What do you mean by this sentence? Sorry no native english speaker.


Am 27.10.2010 12:12, schrieb Emmanuel Florac:
> Le Wed, 27 Oct 2010 12:08:57 +0200
> Stefan Priebe - Profihost AG<s.priebe@profihost.ag>  =E9crivait:
>
>> I'm having 2.6.32 Kernel not 2.6.23 :-) Upgrade works fine yesterday.
>>
>> OK your values are for the iscsi_target right? Should i use the SAME
>> values on the iscsi connector side?
>
> Yes, the initiator values are more important here. Basically, the iscsi
> target service should transmit the initiator's requests as they come.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
