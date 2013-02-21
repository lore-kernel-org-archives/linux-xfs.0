Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 638AF7F51
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 05:47:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EEA7BAC003
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:47:09 -0800 (PST)
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id BaFW9PGeThSbc4CD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Feb 2013 03:47:08 -0800 (PST)
Subject: Re: Ideal RAID-1 Stripe Size for IMAP Server ?
Mime-Version: 1.0 (Apple Message framework v1283)
From: =?iso-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
In-Reply-To: <512607C5.9060004@shiftmail.org>
Date: Thu, 21 Feb 2013 11:46:59 +0000
Message-Id: <62DA4B79-7B29-4D9E-A756-FEC6838E5106@fiton.is>
References: <D991F48F-6D86-4199-9762-698DD7A61895@fiton.is>
	<512607C5.9060004@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

I thought so just after sending this email to the group.
But the ACU(Array Configuration Utility) gives me the option of changing th=
e stripe size
and gives me 256 as default.

So that is irrelevant on RAID1 completely ?

Thanks.





On 21.2.2013, at 11:40, Spelic wrote:

> On 02/21/13 12:11, Svavar =D6rn Eysteinsson wrote:
>> Hi there.
>> =

>> I'm currently configuring a brand new email server(IMAP) which will run
>> CentOS 6.3 x64.
>> =

>> So lots of files on the data volume.
>> =

>> I'm confused about stripe size for my data volume.
>> I'm using 2x500GB for OS in RAID1 and 2x2TB SAS for DATA in RAID1 which =
is
>> hosted on a HP Smart Array P420 Controller with 1GB in Cache/Battery Bac=
ked Up.
>> Both these array's are on the P420 controller.
> =

> Raid1 cannot have "stripes" !?
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
