Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f50.google.com ([209.85.167.50]:38276 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfANRm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 12:42:29 -0500
Received: by mail-lf1-f50.google.com with SMTP id a8so16238077lfk.5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 09:42:28 -0800 (PST)
MIME-Version: 1.0
References: <20190107201355.18996-1-stefanrin@gmail.com> <20190107201355.18996-3-stefanrin@gmail.com>
 <2b4718eb-bf55-600e-2a42-1b3128bf21bf@sandeen.net>
In-Reply-To: <2b4718eb-bf55-600e-2a42-1b3128bf21bf@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Mon, 14 Jan 2019 18:42:14 +0100
Message-ID: <CAAxjCEz5puFW3a7D7exu9wQT5_uHAzt7Tcu2yVuG9PpOEKqbfQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 11, 2019 at 6:31 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 1/7/19 2:13 PM, Stefan Ring wrote:
> > Using basically the same code as in process_single_fsb_objects.
> >
> > Signed-off-by: Stefan Ring <stefanrin@gmail.com>
>
> thanks, the change here to goto write: looks good to me.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, this makes my series fully reviewed. Is there anything left
for me to do now? FWIW, I added the Reviewed-by tag and pushed it to
<https://github.com/Ringdingcoder/xfsprogs-dev/commits/metadump-fully-reviewed>.
