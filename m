Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 08:31:52 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JFVkdo017894
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 08:31:48 -0700
Message-ID: <4677F6E1.50108@dgreaves.com>
Date: Tue, 19 Jun 2007 16:31:45 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <200706191321.07278.rjw@sisk.pl>
In-Reply-To: <200706191321.07278.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>

Rafael J. Wysocki wrote:
>> This is on 2.6.22-rc5
> 
> Is the Tejun's patch
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/30-block-always-requeue-nonfs-requests-at-the-front.patch
> 
> applied on top of that?

2.6.22-rc5 includes it.

(but, when I was testing rc4, I did apply this patch)

David
