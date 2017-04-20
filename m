Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34023 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940967AbdDTE3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 00:29:14 -0400
Received: by mail-oi0-f43.google.com with SMTP id x184so33478270oia.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2017 21:29:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABXGCsMzKE_dVGqf_NnARnkyHR8iGXSiVAek4FsEmFs4-TuDEw@mail.gmail.com>
References: <CABXGCsOUaRMg8ztgeqgN_BbQvPtaSxmyKJZ6hqMnKhO1VA4vmg@mail.gmail.com>
 <20170413200009.GZ8502@birch.djwong.org> <CABXGCsMzKE_dVGqf_NnARnkyHR8iGXSiVAek4FsEmFs4-TuDEw@mail.gmail.com>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
        <mikhail.v.gavrilov@gmail.com>
Date: Thu, 20 Apr 2017 09:28:58 +0500
Message-ID: <CABXGCsMD_k7exKP0sUSm6oeDPWWouxzOrqY9R=_oc5v4wxtW8A@mail.gmail.com>
Subject: Re: inconsistent lock state in kernel 4.11 rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 17 April 2017 at 22:18, =D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB =D0=93=D0=
=B0=D0=B2=D1=80=D0=B8=D0=BB=D0=BE=D0=B2 <mikhail.v.gavrilov@gmail.com> wrot=
e:
> In which mainline kernel version would be merged patch "xfs: drop
> iolock from reclaim context to appease lockdep" ?


Today I updated kernel to rc7 and see that patch still not merged
(messages with "inconsistent lock state" was returned)



--
Best Regards,
Mike Gavrilov.
