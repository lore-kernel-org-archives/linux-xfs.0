Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:38161 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbeEHFg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 01:36:59 -0400
Received: by mail-yb0-f171.google.com with SMTP id w14-v6so10752651ybm.5
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 22:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 08:36:58 +0300
Message-ID: <CAOQ4uxga0DqZF+=R9Nx+XNExrrN6iJLr3uGmSmkwRLAdxB9MRw@mail.gmail.com>
Subject: Re: [PATCH 00/21] Parent Pointers v6
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Hi all,
>
> This is the 6th version of parent pointer attributes for xfs. The goal of

Please try to remember to use git format-patch -v $N as it makes it easier
to lookup old revisions of the patch in the mailbox.

Looking back, I see that Darrick doesn't seem to be tagging individual
patches with revision in his patch bombs as well...

Thanks,
Amir.
