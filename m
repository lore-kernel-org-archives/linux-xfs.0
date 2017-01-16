Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36387 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdAPMm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2017 07:42:29 -0500
Received: by mail-it0-f54.google.com with SMTP id c7so73722700itd.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 04:42:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113165517.GA23576@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-4-git-send-email-jtulak@redhat.com> <20170113165517.GA23576@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 16 Jan 2017 13:42:07 +0100
Message-ID: <CACj3i72_JC8ZQ0+gpz0Q=PzGm8qSBo1+o2=Dwv1kxt-z4Nvw0g@mail.gmail.com>
Subject: Re: [PATCH 03/22] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 5:55 PM, Bill O'Donnell <billodo@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 02:27:10PM +0100, Jan Tulak wrote:
>> Add a new field int opt_params - value, which is filled with user input.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> Despite a very minor whitespace issue...
>
> Reviewed-by: Bill O'Donnell <billodo@redhat.com>
>

Whitespace fixed. Thanks for the review. :-)

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
