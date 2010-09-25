Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PEHst9236938 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:17:55 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5B251D93F58
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 07:18:50 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	54xBokomHEWnYKsl for <xfs@oss.sgi.com>;
	Sat, 25 Sep 2010 07:18:50 -0700 (PDT)
Received: by iwn39 with SMTP id 39so3101070iwn.26
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 07:18:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100925161357.0a30e20a@galadriel.home>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<AANLkTimXCo0YtjmdPo9RvX=KfQCjJkkL9hQr3h63UJX7@mail.gmail.com>
	<20100924201807.16460606@galadriel.home>
	<4C9D0E3B.20007@open-e.com>
	<20100925161357.0a30e20a@galadriel.home>
Date: Sat, 25 Sep 2010 07:18:50 -0700
Message-ID: <AANLkTinJ+V7-yuqOM2EDfS243h-0HMm9WEgGoTySmyWe@mail.gmail.com>
Subject: Re: Problem with file system on iSCSI FileIO
From: Richard Sharpe <realrichardsharpe@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, ryszard.stawiarski@open-e.com, =?ISO-8859-2?Q?=A3ukasz_Wittig?= <lukasz.wittig@open-e.com>, Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Slawomir Nowakowski <slawomir.nowakowski@open-e.com>

On Sat, Sep 25, 2010 at 7:13 AM, Emmanuel Florac <eflorac@intellique.com> w=
rote:
> Le Fri, 24 Sep 2010 22:46:51 +0200 vous =E9criviez:
>
>> I C that there is no problem with IETD ;-)
>> But we need to stay focused on SCST in this case :-)
>>
>
> Yes but you'd need to get sure that it's not scst that breaks the
> filesystem. My guess : it actually is. *I personnally didn't find SCST
> of acceptable production quality.*

Great call there ... I see that Data Domain, Fusion IO and others have
ignored your sage advice and suffered the financial consequences.

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
