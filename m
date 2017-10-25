Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:54041 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbdJYOyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 10:54:36 -0400
Received: by mail-it0-f50.google.com with SMTP id n195so1348100itg.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 07:54:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8d15394e-1dd6-ced0-7af1-fb538c60bb58@aei.mpg.de>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
 <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com> <8d15394e-1dd6-ced0-7af1-fb538c60bb58@aei.mpg.de>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 25 Oct 2017 16:54:35 +0200
Message-ID: <CAAxjCEz78rDh-DfO7zXn_GFLagZFUsJbKi63bw8SgDECq62c8Q@mail.gmail.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve files?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2017 at 1:51 PM, Carsten Aulbert
<carsten.aulbert@aei.mpg.de> wrote:
> But on the other hand, given that this was a single disk rebuild in a
> RAID6 (10+2) in theory it should not impact anything working on the
> block device level or above except for timeouts/slowness ;)

True, in theory. Although it sounds suspiciously like this is
precisely what happened.
