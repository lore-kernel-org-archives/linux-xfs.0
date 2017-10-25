Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:51176 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdJYLcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 07:32:39 -0400
Received: by mail-it0-f41.google.com with SMTP id 72so642825itl.5
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 04:32:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 25 Oct 2017 13:32:38 +0200
Message-ID: <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve files?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Carsten Aulbert <carsten.aulbert@aei.mpg.de>

On Wed, Oct 25, 2017 at 9:20 AM, Carsten Aulbert
<carsten.aulbert@aei.mpg.de> wrote:
> Hi
>
> after some hiatus, back on this list with an incident which happened
> yesterday:
>
> On a Debian Jessie machine installed back in October 2016 there a re a
> bunch of 3TB disks behind an Adaptec ASR-6405[1] in RAID6 configuration.
> Yesterday, one of the disks failed and was subsequently replace. About
> an hour into the rebuild the 28TB xfs on this block device gave up:

Did the RAID rebuild complete at least?
