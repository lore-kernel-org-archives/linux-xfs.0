Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE49D7F74
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 09:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E576304053
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 07:23:45 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id MjAAvCX9RA8n8nrz for <xfs@oss.sgi.com>;
	Fri, 29 Mar 2013 07:23:44 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by pirx.askja.de (Postfix) with ESMTP id 647C6300A1
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 15:23:41 +0100 (CET)
Received: from pirx.askja.de ([127.0.0.1])
	by localhost (pirx.askja.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ebeoyvGYY+ib for <xfs@oss.sgi.com>;
	Fri, 29 Mar 2013 15:23:41 +0100 (CET)
Date: Fri, 29 Mar 2013 15:23:40 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: Help with XFS in VMs on VMFS
Message-ID: <20130329142340.GB3771@pirx.askja.de>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
	<20130328214550.GA3771@pirx.askja.de>
	<20130328231306.1af76eea@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130328231306.1af76eea@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Emmanuel Florac schrieb:
> Le Thu, 28 Mar 2013 22:45:50 +0100 vous =E9criviez:
> =

> > I'm seeing more and more requests for VMs with large disks lately in
> > my env. Right now the max. is ~2 TB. I'm also thinking about where to
> > go,
> >  > 2 TB ist only possible with pRDMs which can't be snapshotted. You  =

> > have to use the snapshot features of your storage array.
> =

> Maybe you could give LVM snapshot a new try. They got better recently.

I need the bigger disks for win VMs ;)

Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
