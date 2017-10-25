Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:53671 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbdJYO4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 10:56:32 -0400
Received: by mail-io0-f177.google.com with SMTP id 189so1274992iow.10
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 07:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEz78rDh-DfO7zXn_GFLagZFUsJbKi63bw8SgDECq62c8Q@mail.gmail.com>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
 <CAAxjCEwEH-OsH_z=OWg0R7XoOzyWeUQsmTp1r8Fdp-JU11eX4Q@mail.gmail.com>
 <8d15394e-1dd6-ced0-7af1-fb538c60bb58@aei.mpg.de> <CAAxjCEz78rDh-DfO7zXn_GFLagZFUsJbKi63bw8SgDECq62c8Q@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 25 Oct 2017 16:56:31 +0200
Message-ID: <CAAxjCEz0VbGJvq7S09hDcEBkomMGTeCXKHvxrV8BQ1+pXY49qA@mail.gmail.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve files?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-xfs@vger.kernel.org

Anyway, it would be good to know if the RAID got mixed up somehow or
not. In the former case, I would kiss the data good bye. Otherwise it
should be recoverable, although it might be time consuming.
