Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VCu84G062221 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 07:56:08 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 550093CDA2
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 05:56:46 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 7Qtg1X7QKVjadArV
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 05:56:46 -0700 (PDT)
Message-ID: <4C7CFC08.1000708@profihost.ag>
Date: Tue, 31 Aug 2010 14:56:40 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS Quota Check OOM
References: <4C7BA0A0.5090202@profihost.ag>	<4C7CB0FE.1020302@profihost.ag>	<20100831104418.058ab6b5@galadriel.home>	<4C7CF4C4.9030105@profihost.ag>
	<20100831144319.7e97acea@galadriel.home>
In-Reply-To: <20100831144319.7e97acea@galadriel.home>
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
Cc: xfs@oss.sgi.com


Oh we don't do this today. But it is a really old system where someone =

someday decided to do that. Sadly i can't change this...

Stefan

Am 31.08.2010 14:43, schrieb Emmanuel Florac:
> Le Tue, 31 Aug 2010 14:25:40 +0200 vous =E9criviez:
>
>> Disk Size:
>> /dev/sda3             4.8T  2.7T  2.2T  55% /
>
> This is really very very weird. Why on earth would you use such a big
> root filesystem? It is extremely impractical and dangerous to store
> data on the root filesystem. Do you have any good reason not to have a
> small root filesystem and a distinct data one?
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
