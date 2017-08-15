Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35595 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752685AbdHOUcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 16:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAPaz=E+sPDK3uWYCepmYPMT2+nvTgA2C_OSyPY0a51iM=bBCsQ@mail.gmail.com>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
 <20170815173349.GA17774@li70-116.members.linode.com> <CAPaz=E+sPDK3uWYCepmYPMT2+nvTgA2C_OSyPY0a51iM=bBCsQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 15 Aug 2017 22:32:41 +0200
Message-ID: <CAOQ4uxhkT05yHfQz0csruH-mz_hTamMABh3eZaNmzjXX02J1=A@mail.gmail.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System Crash Consistency
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.og, Ashlie Martinez <ashmrtn@utexas.edu>

On Tue, Aug 15, 2017 at 8:01 PM, Vijay Chidambaram <vvijay03@gmail.com> wrote:
> Hi Josef and Amir,
>
...
>
> @Amir: Given that Josef's code is already in the kernel, do you think
> changing CrashMonkey code would be useful? We are always happy to
> provide something for upstream, but we want to be sure how much work
> would be involved.
>

Simply put, people (myself included) are more likely to use CrashMonkey
if it uses upstream kernel and/or if it brings valuable functionality
to filesystem
testing, beyond what log-writes already does -
I am have not studies either tools yet to be able to determine if that
is the case.

Cheers,
Amir.
